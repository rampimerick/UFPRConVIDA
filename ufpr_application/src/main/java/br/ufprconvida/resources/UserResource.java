package br.ufprconvida.resources;

import java.net.URI;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import br.ufprconvida.domain.User;
import br.ufprconvida.services.UserService;
import javassist.tools.rmi.ObjectNotFoundException;

@RestController
@RequestMapping(value = "/users")
public class UserResource {

    @Autowired
    private UserService service;


    @GetMapping
    public ResponseEntity<List<User>> findAll(){
        List <User> users = service.findAll();
        return ResponseEntity.ok().body(users);
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> findById(@PathVariable String id) throws ObjectNotFoundException {
        User obj = service.findById(id);
        return ResponseEntity.ok().body(obj);
    }

    @PostMapping 
    public ResponseEntity<Void> insert(@RequestBody User user){
        user = service.insert(user);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(user.getGrr()).toUri();
        return ResponseEntity.created(uri).build();
    }

    
}