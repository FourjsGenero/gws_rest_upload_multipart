#
# FOURJS_START_COPYRIGHT(U,2015)
# Property of Four Js*
# (c) Copyright Four Js 2015, 2015. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
# 
# Four Js and its suppliers do not warrant or guarantee that these samples
# are accurate and suitable for your purposes. Their inclusion is purely for
# information purposes only.
# FOURJS_END_COPYRIGHT
#

IMPORT os
IMPORT com

MAIN
  DEFINE req  com.HTTPRequest
  DEFINE resp com.HTTPResponse
  DEFINE part com.HTTPPart
  DEFINE ind  INTEGER
  
  IF num_args()<3 THEN
    CALL ShowUsage()
    EXIT PROGRAM
  END IF
  
  LET req = com.HTTPRequest.Create(arg_val(1))
  
  # Use POST
  CALL req.setMethod("POST")
  
  # Zip content
  CALL req.setHeader("Content-Encoding","gzip")
  
  # Set multipart : form-data
  CALL req.setMultipartType("form-data",NULL,NULL)

  # Attach each file
  FOR ind = 3 TO num_args()
    LET part = com.HTTPPart.CreateAttachment(arg_val(ind))
    CALL part.setHeader("Content-Disposition",CreatePartContentDisposition("file"||ind,arg_val(ind)))
    # TODO : detect extension type and set correct Content-Type
    # CALL part.setHeader("Content-Type","text/plain")
    CALL req.addPart(part)
  END FOR
  
  # Send main part 
  CALL req.setHeader("Content-Disposition",'form-data; name=\"folder\"')
  CALL req.doTextRequest(arg_val(2))
  
  # Process response
  LET resp = req.getResponse()
  IF resp.getStatusCode() == 200 THEN
    DISPLAY "Done."
    DISPLAY resp.getTextResponse()
  ELSE
    DISPLAY "Failed."
    DISPLAY resp.getTextResponse()
  END IF

END MAIN

#
# Helper to format part header as a browser in form-data does
#
FUNCTION CreatePartContentDisposition(name,filename)
  DEFINE  name      STRING
  DEFINE  filename  STRING
  DEFINE  ret       STRING
  IF name IS NULL THEN
    RETURN NULL
  END IF
  LET ret = 'form-data; name=\"'||name||'\"'
  IF filename IS NOT NULL THEN
    LET ret = ret || '; filename=\"'||filename||'\"'
  END IF
  RETURN ret
END FUNCTION

FUNCTION ShowUsage()
  DISPLAY "FileUploadClient url dest [files]"
  DISPLAY "  url   : server URL location"
  DISPLAY "  dest  : the destination folder"
  DISPLAY "  files : a list of file to upload on dest folder"
  DISPLAY ""
  DISPLAY "Uploads given files to the server in dest folder"
  DISPLAY "  FileUploadClient http://localhost:8090/Uploading MyFolder file.txt image.jpg"
END FUNCTION
