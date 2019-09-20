package br.ufprconvida.resources;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.ufprconvida.domain.User;
import br.ufprconvida.services.UserService;
import javassist.tools.rmi.ObjectNotFoundException;

@RestController
@RequestMapping(value = "/users")
public class UserResource {

    @Autowired
    private UserService service;

    @GetMapping("/{id}")
    public ResponseEntity<User> findById(@PathVariable String id) throws ObjectNotFoundException {
        User obj = service.findById(id);
        return ResponseEntity.ok().body(obj);
    }
}