
  FOURJS_START_COPYRIGHT(U,2015)
  Property of Four Js*
  (c) Copyright Four Js 2015, 2015. All Rights Reserved.
  * Trademark of Four Js Development Tools Europe Ltd
    in the United States and elsewhere
  
  Four Js and its suppliers do not warrant or guarantee that these samples
  are accurate and suitable for your purposes. Their inclusion is purely for
  information purposes only.
  FOURJS_END_COPYRIGHT

FileUploading REST service demonstration

For this FileUploading REST service demonstration, the
client sends all file provided at command line of current directory
to a UploadingService located at given URL.
The server will first create a new directory and save all files
in it. If directory already exists, the server will answer with an
error message. In case of success, the server responds a summary
of the file uploaded to the client.

==============
Prerequisites:
==============

Before starting, make sure that the environment variables 
PATH, FGLDIR, and FGLSERVER are properly set. See the 
Genero Business Development Language documentation for more
information on setting environment variables.

By default, these examples use the TCP port number 8090.
If the port number 8090 is used by another application on 
your machine, choose another port number.

===============
How to execute:
===============

On Windows:
- Modify the server and client build.bat files to change the port 
  number (if required)
- Run first 'build.bat' and then 'run.bat' in the server directory
- In a second DOS session, run 'build.bat' in the client directory
  and do : 
  %FGLRUN% FileUploadClient http://localhost:8090/Upload MyUploadDirectory
         file.txt img.jpg any.pdf
  or load the upload.html file in your browser to upload files

On Unix:
- Modify the server and client makefile to change the port 
  number (if required)
- Execute 'make' and then 'make run' in the server directory
- In a new shell session, execute 'make' and then do:
  $FGLRUN FileUploadClient http://localhost:8090/Upload MyUploadDirectory
         file.txt img.jpg any.pdf
  or load the upload.html file in your browser to upload files

NOTE1: The given files will all be uploaded on server side in the new created
      directory called 'MyUploadDirectory' on current directory where the
      server is running.

NOTE2: If the server directory already exists or has no write access,
       the server will return an error message
      
