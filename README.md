These VBS scripts are designed to run in SecureCRT to facilitate injection of 2fa keys for CyberArk Proxys.

The setup for these are very extensive and listed in the comment section of each script but here are the basics:

1. Install and configure rsc/2fa

2. Be sure that SecureCRT's shell can call the rsc/2fa program and .2fa config file

3. Add a session in SecureCRT to store password in the root of your sessions called "Discovery"
