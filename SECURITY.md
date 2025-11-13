# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## Reporting a Vulnerability

We take the security of Chat Simulator seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### How to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via:
1. GitHub Security Advisories (preferred)
2. Opening a private security issue on GitHub

Include the following information:
- Type of vulnerability
- Full paths of source file(s) related to the vulnerability
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the vulnerability, including how an attacker might exploit it

### What to Expect

- You should receive an acknowledgment within 48 hours
- We will send a more detailed response within 7 days indicating next steps
- We will keep you informed about the progress toward a fix
- We may ask for additional information or guidance

## Security Best Practices

### For Users

1. **Password Security**
   - Use strong passwords (at least 6 characters, but longer is better)
   - Don't reuse passwords from other services
   - This is a demonstration project - don't use real passwords

2. **Data Storage**
   - The `.chat_data.etf` file contains hashed passwords
   - Keep this file secure and don't share it
   - In production, consider encrypting the entire data file

3. **Network Security**
   - Currently, Chat Simulator is local-only
   - If extending for network use, implement TLS/SSL
   - Add rate limiting to prevent abuse

### For Developers

1. **Password Hashing**
   - Currently uses SHA256
   - For production use, migrate to bcrypt, argon2, or pbkdf2
   - Never store plain text passwords

2. **Input Validation**
   - All user input is validated
   - Message content is limited to 500 characters
   - Usernames follow strict patterns

3. **Dependencies**
   - Keep dependencies up to date
   - Monitor security advisories
   - Use Dependabot for automated updates

4. **Code Review**
   - All changes should be reviewed
   - Security-sensitive changes require extra scrutiny
   - Run static analysis tools (Credo, Dialyzer)

## Known Limitations

This is an educational project with the following security limitations:

1. **Password Hashing**: Uses SHA256 instead of bcrypt/argon2
2. **Session Management**: Basic in-memory session handling
3. **Data Encryption**: Data stored unencrypted on disk
4. **Rate Limiting**: No protection against brute force attacks
5. **Input Sanitization**: Basic validation only

These limitations are documented for educational purposes. For production use, these should be addressed.

## Security Enhancements (Roadmap)

Planned security improvements:

- [ ] Implement bcrypt or argon2 for password hashing
- [ ] Add data encryption at rest
- [ ] Implement rate limiting
- [ ] Add session timeout mechanism
- [ ] Implement account lockout after failed attempts
- [ ] Add audit logging for security events
- [ ] Implement secure password reset mechanism
- [ ] Add two-factor authentication option

## Attribution

We appreciate the security research community and will acknowledge researchers who responsibly disclose vulnerabilities (with their permission).

## Policy Updates

This security policy may be updated from time to time. Please check back regularly for updates.

Last updated: 2025-11-13
