package br.ufprconvida.resources;

import java.net.URI;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import br.ufprconvida.domain.Event;
import br.ufprconvida.services.EventService;
import javassist.tools.rmi.ObjectNotFoundException;

@RestController
@RequestMapping(value = "/events")
public class EventResource {

    @Autowired
    private EventService service;
  

    @GetMapping
    public ResponseEntity<List<Event>> findAll() {
        List<Event> list = service.findAll();
        return ResponseEntity.ok().body(list);

    }

    @GetMapping(value = "/{id}")
    public ResponseEntity<Event> findById(@PathVariable String id) throws ObjectNotFoundException {
        Event obj = service.findById(id);
        return ResponseEntity.ok().body(obj);

    }

    @PostMapping
    public ResponseEntity<Void> insert(@RequestBody Event obj){
        obj = service.insert(obj);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(obj.getId()).toUri();
        return ResponseEntity.created(uri).build();
    }

    @PutMapping(value = "/update/{id}")
    public ResponseEntity<Void> update(@RequestBody Event event, @PathVariable String id){
        event.setId(id);
        event = service.update(event);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping(value = "/delete/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id ) throws ObjectNotFoundException {
        service.delete(id);
        return ResponseEntity.noContent().build();

    }

}