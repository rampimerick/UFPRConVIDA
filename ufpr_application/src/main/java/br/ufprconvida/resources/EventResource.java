package br.ufprconvida.resources;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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

    @GetMapping("/{id}")
    public ResponseEntity<Event> findById(@PathVariable String id) throws ObjectNotFoundException {
        Event obj = service.findById(id);
        return ResponseEntity.ok().body(obj);

    }



}