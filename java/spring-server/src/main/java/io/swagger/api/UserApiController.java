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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.constraints.*;
import javax.validation.Valid;
@javax.annotation.Generated(value = "io.swagger.codegen.languages.SpringCodegen", date = "2017-10-10T23:13:12.942Z")

@Controller
public class UserApiController implements UserApi {
    Map<String, User> userIDMap = new HashMap<>();

    public ResponseEntity<Void> createUser(@ApiParam(value = "Created user" ,required=true )  @Valid @RequestBody User body) {
        // add user if username not present
        if (userIDMap.putIfAbsent(body.getUsername(), body) != null) {
            return new ResponseEntity<Void>(HttpStatus.CREATED);
        }
        return new ResponseEntity<Void>(HttpStatus.OK);
    }

    public ResponseEntity<Void> deleteUser(@ApiParam(value = "The user that needs to be deleted",required=true ) @PathVariable("username") String username) {
        if (userIDMap.remove(username) == null) {
            return new ResponseEntity<Void>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<Void>(HttpStatus.OK);
    }

    public ResponseEntity<User> getUserByUsername(@ApiParam(value = "The name that needs to be retrieved. ",required=true ) @PathVariable("username") String username) {
        User user = userIDMap.get(username);
        if (user == null) {
            return new ResponseEntity<User>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<User>(user, HttpStatus.OK);
    }

    public ResponseEntity<Void> updateUser(@ApiParam(value = "name that need to be updated",required=true ) @PathVariable("username") String username,
        @ApiParam(value = "Updated user" ,required=true )  @Valid @RequestBody User body) {
        if (userIDMap.replace(body.getUsername(), body) == null) {
            return new ResponseEntity<Void>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<Void>(HttpStatus.OK);
    }

}
