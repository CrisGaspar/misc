package io.swagger.api;

import io.swagger.model.User;

import io.swagger.annotations.*;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

import javax.validation.constraints.*;
import javax.validation.Valid;
@javax.annotation.Generated(value = "io.swagger.codegen.languages.SpringCodegen", date = "2017-10-10T23:13:12.942Z")

@Controller
public class UserApiController implements UserApi {



    public ResponseEntity<Void> createUser(@ApiParam(value = "Created user" ,required=true )  @Valid @RequestBody User body) {
        // do some magic!
        return new ResponseEntity<Void>(HttpStatus.OK);
    }

    public ResponseEntity<Void> deleteUser(@ApiParam(value = "The user that needs to be deleted",required=true ) @PathVariable("username") String username) {
        // do some magic!
        return new ResponseEntity<Void>(HttpStatus.OK);
    }

    public ResponseEntity<User> getUserByUsername(@ApiParam(value = "The name that needs to be retrieved. ",required=true ) @PathVariable("username") String username) {
        // do some magic!
        return new ResponseEntity<User>(HttpStatus.OK);
    }

    public ResponseEntity<Void> updateUser(@ApiParam(value = "name that need to be updated",required=true ) @PathVariable("username") String username,
        @ApiParam(value = "Updated user $name" ,required=true )  @Valid @RequestBody User body) {
        // do some magic!
        return new ResponseEntity<Void>(HttpStatus.OK);
    }

}
