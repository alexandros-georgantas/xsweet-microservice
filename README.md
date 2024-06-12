# XSWEET service

## The service

This standalone service exposes the functionality of converting a docx file into html. The API offered is as follows:

- `POST /api/auth`
- `POST /api/docxToHTML`

1. As this service is meant to be from many clients, the first endpoint allows clients to acquire their access tokens in order to be able to use the service\*. A call to the `api/auth` endpoint considered valid if it contains the Authorization header with value `Basic base64encoded(clientId:clientSecret)`.  
   The response of a valid call to the `api/auth` will return an `accessToken`\*\* (JWT)
2. A call to the `api/docxToHTML` in order to be considered valid should have the `Authorization` property in its headers with value `Bearer <the value of an accessToken provided by this service>`. The property `Content-Type` should be `multipart/form-data` and finally the body should contain the actual docx file under a form field called `docx`.  
   The response of this endpoint will be a `JSON` object:

- `html`: the converted content
- `msg`: the error message if anything goes wrong

\*client's registration required beforehand  
\*\*the life span of an accessToken is 8 hours

## Starting the service

The service is fully dockerized for ease of use for either development or for use in production.

### Development

In the root of the service run `docker-compose up`  
This container includes the actual service as well as a Postgres DB

### Production

In the root of the service run `docker-compose -f docker-compose.production.yml up`
This container contains just the service. An external Postgres DB should be provided.

### Required env variables

```
PUBSWEET_SECRET
SERVER_PORT
SERVER_HOST
SERVER_PROTOCOL
POSTGRES_USER
POSTGRES_PASSWORD
POSTGRES_HOST
POSTGRES_DB
POSTGRES_PORT
NODE_ENV=production
```

All the above are required

## Creating client's credentials

When the service is up by executing `docker exec -it <name_of_the_xsweet_server_container> yarn create:client`.  
The above will produce a valid pair of clientId and clientSecret

## Flags

This service runs a single pipeline of XSweet scripts. However, there are a few flags that can be set to change post-processing behavior. Pass these as keys in the body of the request to the service.

 - **useMath**: if this is `true`, this will try to convert any WMF files to MathML - if MathType has been used in Word, equations will be stored as binary WMF files. Not all WMF files are Mathtype. By default, this isn't run.
 - **useBox**: if this is `true`, paragraph elements with a `data-style` attribute coming out of XSweet will be wrapped in `<aside class="short note">`, which works with the OEN tools in Wax. If this isn't run, the attribute will be passed through, though it will probably be stripped out by Wax.

## Mathtype

This uses a Ruby gem to decode binary MathType files that are found inside of the DOCX file; otherwise, these files would be output as WMF files, which can't be viewed by a browser. Not all WMF files are MathType.