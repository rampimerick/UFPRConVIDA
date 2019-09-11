package br.ufprconvida.services;

import java.util.List;
import java.util.Optional;

import br.ufprconvida.domain.Event;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.ufprconvida.repository.EventRepository;
import javassist.tools.rmi.ObjectNotFoundException;

@Service
public class EventService{

    @Autowired
    private EventRepository repo;

    public List<Event> findAll(){
        return repo.findAll();
        
    }

    public Event findById(String id) throws ObjectNotFoundException {
        Optional <Event> event = repo.findById(id);
        return event.orElseThrow(() -> new ObjectNotFoundException("não existe"));

    }

}