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

IMPORT com
IMPORT os 

#
# USER GLOBALS VARIABLES
#

MAIN
  DEFINE req      com.HTTPServiceRequest
  DEFINE url      STRING
  DEFINE meth     STRING
  DEFINE type     STRING
  DEFINE dest     STRING
  DEFINE part     com.HTTPPart
  DEFINE ind      INTEGER
  DEFINE txt      STRING
  
  CALL com.WebServiceEngine.Start()

  WHILE true
    LET req = com.WebServiceEngine.getHTTPServiceRequest(-1)
    
    LET url = req.getURL()
    # Check URL
    IF url IS NULL THEN
      CALL req.sendResponse(400,NULL)
      CONTINUE WHILE
    END IF
    
    # Ensure method is POST
    LET meth = req.getMethod()
    IF meth IS NULL OR meth != "POST" THEN
      CALL req.sendTextResponse(400,NULL,"Only post supported")
      CONTINUE WHILE
    END IF

    # Check multipart type
    LET type = req.getRequestMultipartType()
    IF type IS NULL THEN
      CALL req.sendTextResponse(400,NULL,"Multipart required")
      CONTINUE WHILE
    END IF
    
    # Check main part to get destination name
    LET dest = req.readTextRequest()
    DISPLAY "Uploading on folder:",dest
    IF os.Path.exists(dest) THEN
      CALL req.sendTextResponse(400,NULL,"Destination folder already exists")
      CONTINUE WHILE
    ELSE
      LET ind = os.Path.mkdir(dest)
      IF ind != TRUE THEN
        CALL req.sendTextResponse(400,NULL,"Cannot create destination folder")
        CONTINUE WHILE
      ELSE
      END IF
    END IF

    # CD to dest directory
    LET ind = os.Path.chdir(dest)

    LET txt = "Uploading summary:"
    # Process additional parts
    FOR ind = 1  TO req.getRequestPartCount()
     LET part = req.getRequestPart(ind)
     IF part.getAttachment() IS NOT NULL THEN
       LET txt = txt || "\n" || CopyAttachmentTo(ind,part)
     ELSE
       LET txt = txt || "\n" || "Warning: don't know how to handle part :",part.getContentAsString()
     END IF    
    END FOR
    # Get back to original directory
    LET ind = os.path.chdir("..")
    
    # Process response
    CALL req.sendTextResponse(200,NULL,txt)
  END WHILE
END MAIN

FUNCTION CopyAttachmentTo(ind,p)
  DEFINE  ind   INTEGER
  DEFINE  p     com.HTTPPart
  DEFINE  i     INTEGER
  DEFINE  name  STRING  
  
  # Extract attachment name (if any) from header
  LET name = ExtractFilenameFromAttachment(p)
  IF name is NULL THEN
    LET name = "unknown"||ind
  END IF
  
  Display "Copying attachment #"||ind||" named :",name
  LET i = os.Path.copy(p.getAttachment(),name)
  IF i THEN
    RETURN "Part #"||ind||" uploaded as "||name
  ELSE
    RETURN "Warning: Part #"||ind||" fail to upload"
  END IF
END FUNCTION

#
# Helper to get filename from attachment headers
#
FUNCTION ExtractFilenameFromAttachment(p)
  DEFINE  p     com.HTTPPart
  DEFINE  str   STRING
  DEFINE  name  STRING
  DEFINE  i,j   INTEGER

  # Name is in Content-Disposition header
  LET str = p.getHeader("Content-Disposition")
  
  # Extract attachment filename (if any) from header  
  LET i = str.getIndexOf("filename=\"",1)
  IF i>0 THEN
    LET j= str.getIndexOf("\"",i+10)
    IF j>0 THEN
      LET name = str.substring(i+10,j-1)
      RETURN name
    END IF
  END IF
  # Extract attachment name from header then
  LET i = str.getIndexOf("name=\"",1)
  IF i>0 THEN
    LET j= str.getIndexOf("\"",i+6)
    IF j>0 THEN
      LET name = str.substring(i+6,j-1)
      RETURN name
    END IF
  END IF  
  
  # No name found
  RETURN NULL 
END FUNCTION

