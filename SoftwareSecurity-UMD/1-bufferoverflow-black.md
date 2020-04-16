# Software Security - Lecture 1

- An Opening
	- Undesired Behaviors
		- Stealing information => ~~Confidentiality~~
		- Modifying information => ~~Integrity~~
		- Denying access => ~~Availability~~
	- Black Hat & White Hat
		- We will play both roles in this course

## Topic 1: Low-Level Security - Buffer Overflow
- Critical Systems in C/C++

### 1. Review - Memory Layout
- Process Address Space
	- 0x00000000 ~ 0xffffffff (4 GB)
		- These are virtual addresses, and the OS/CPU maps them to physical memory addresses
	- Known at **Compile Time**
		- Code (Text) Segment
		- Data Segment
			- Initialized Data Area, `static const int y = 10;`
			- Unitialized Data Area, `static inx x;`
	- Known at **Runtime**
		- Heap
		- Stack
	- At the top of address space, set when process starts
		- cmdline & env

- Function Call & Return:
	1. Caller:
		- Push the arguments in reverse order of code
			- `| ... | arg1 | arg2 | arg3 | caller's frame |`
		- Push the caller's *instruction pointer* stored in `%eip` register onto the callee's **stack frame**
			- `| ... | %eip | arg1 | arg2 | arg3 | caller's frame |`
			- *Instruction Pointer*: points to the position where caller makes the funciton call => indicates the return address
		- Jump to the callee function's address

	2. Callee:
		- Push the caller's *frame pointer* stored in `%ebp` register onto the stack
			- `| ... | %ebp | %eip | arg1 | arg2 | arg3 | caller's frame |`
			- *Frame Pointer*: points to caller's stack address
		- Set new *frame pointer* (i.e. `%ebp` register) to where the end of the stack is right now (stack pointer, i.e. `%esp` register)
		- Push local variables onto the stack
			- `| ... | loc2 | loc1 | %ebp | %eip | arg1 | arg2 | arg3 | caller's frame |`

	3. Return:
		- Reset the previous stack frame: `%esp = %ebp, %ebp = (%ebp)`
		- Jump back to return address: `%eip = 4(%esp)`

### 2. Buffer Overflows
- Buffer?
	- Contiguous memory associated with a variable or field
- Overflows?
 	- Read/Put more data into the buffer than it holds
	 	- e.g., `strcpy` allows you to write as much as you want
	 	- User-Supplied Strings
	 		- **Validating assumptions** about user input is important

```C
void func(char *arg1) {
	int authenticated = 0;
	char buffer[4];
	strcpy(buffer, arg1);
	if (authenticated) {
		// do something
	}
}

int main() {
	char *mystr = "AuthMe!";
	func(mystr);
	// do something
}

```

#### Code Injection
1. Loading Code into Memory
- Chanllenges
	- It must be *machine code* instructions
	- Carefully construct it
		- e.g. cannot contain any all-zero bytes
	- The code must be complete: cannot use the loader
- What Code to Run
	- General-Purpose Shell

```shell
int main () {
	char *name[2];
	name[0] = "/bin/sh";
	name[1] = NULL;
	execve(name[0], name, NULL);
}
```

2. Getting Injected Code to Run
- Hijacking Saved `%eip`
	- According to `%eip = 4(%esp)`, try replacing the stored `%esp` and make the program execute your code after function return
	- Problem: how can we know the address?
		- If we pick the wrong address, the program would crash

3. Finding the Return Address
- If we don't have the code, we cannot know how far the buffer is from the saved `%ebp`
- Methods
	- Brute force: try a lot of values (2^64)
	- If without address randomization
		- The stack always starts from a **fixed address**
	- `nop` sleds
		- A single-byte instruction towards moving to the next instruction

### 3. Other Memory Expolit Attack
1. Heap Overflow
	- Fruitful structrues to overflow: other fields of the same struct the buffer is in, data structures used by the memory allocator, nearby objects also allocated by malloc
	- In the C example, the code only works properly when `strlen(one)+strlen(two) < MAX_LEN`
		- Otherwise, `s->cmp` will be overwritten

```c
typedef struct _vulnerable_struct {
	char buff[MAX_LEN];
	int (*cmp)(char*, char*);	// compare
} vulnerable;

int foo(vulnerable* s, char* one, char* two) {
	strcpy( s->buff, one );		// copy one into buff
	strcpy( s->buff, two );		// copy two into buff
	return s->cmp( s->buff, "file://foobar");
}
```

2. Heap Overflow Variants
- Overflow into C++ Object Vtable
	- C++ objects virtual method table contains pointers to the object's methods
- Overflow into Adjacent Objects
- Overflow Heap Metadata 

3. Integer Overflow

```c
void vulnerable() {
	char* response ;
	int nresp = packet_get_int();		// make the integer very huge
	if (nresp > 0) {
		response = malloc (nresp*sizeof(char*));
		for (i = 0; i < nresp; i++)
			response[i] = packet_get_string(NULL);	// overflow
	}
}
```

4. Corrupting Data
- Overflow data
	- Modify a secret key
	- Modify state variables
	- Modify interpreted string, e.g. SQL
- An example of *read overflow*
	- Intended functionality of this program
		- First read an integer (length)
		- Then read a message
		- Finally echo back the message
	- Problem: the length specified may exceed the actual message length => leaked data
	- Real case: the **Heartbleed bug**

```c
int main() {
	char buf[100], *p;
	int i, len;
	while (1) {
		p = fget(buf, sizeof(buf), stdin);
		if (p == NULL) return 0;
		len = atoi(p);

		p = fget(buf, sizeof(buf), stdin);
		if (p == NULL) return 0;

		for (i = 0; i < len; i++) {
			if (!iscntrl(buf[i])) putchar(buf[i]);
			else putchar('.');
		}
		printf("\n");
	}
}
```

5. Stale Memory
- Dangling Pointer Bug: a freed pointer continues to be used by the program
	- The attacker can arrange for the freed memory to be *reallocated*

```c
struct foo { int (*cmp)(char*, char*); };
struct foo *p = malloc(...);
free(p);
// ...
q = malloc(...) 			// reuses the freed memory
*q = 0xdeadbeef				// attacker control
// ...
p->cmp("hello", "hello");	// use dangling pointer
```

6. Formatted String Attack
- Format Specifiers
	- Position in string indicates stack argument to print
	- However, buff may *itself contains* format specifiers, thus makes the program valnerable

```c
void vulnerable() {
	char buf[80];
	if (fgets(buf, sizeof(bug), stdin) == NULL) return;
	printf(buf);
}

void safe() {
	char buf[80];
	if (fgets(buf, sizeof(bug), stdin) == NULL) return;
	printf("%s", buf);
}

// a piece of code
int i = 10;
printf("%d %p\n", i, &i);
```

Based on the above code block:

1. How Format Specifiers Work
	- ` | ... | %ebp | %eip | %fmt | 10 | &i | `
	- `%fmt` is the formatted string
2. How `vulnerable()` becomes vulnerable
	- ` | ... | %ebp | %eip | %fmt | caller's stack frame | `
	- It reads the data in caller's stack frame, if `%fmt` is carefully designed
		- Malevolent code examples
			- `printf("%d %d %d %d")` print a series of stack entries as integers
			- `printf("100% no way!")` **writes** the number 3 to address pointed to by stack entry
				- Because `"%n"` writes the progress that `printf` made in printing the output stream
