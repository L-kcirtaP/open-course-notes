# Software Security

## Topic 3: Web Security
- New vulnerabilities to consider
	- Web 1.0: **SQL injection**
	- The web with state:  **Session Hijacking**, Cross-Site Request Forgery (**CSRF**)
	- Web 2.0 (the advent of JS): Cross-Site Scripting (**XSS**)

### 1. Web Basics
- HTTP Protocol
	- An application-layer protocol
	- HTTP Request
		- Types: GET or POST
		- URL of the resource
		- Headers:
			- Host
			- User-Agent
			- Referer: the site from which this request was issued
	- HTTP Response
		- Status code (reason phrase)
		- Headers
			- Cookies
		- Data

### 2. SQL Injection
