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
        return event.orElseThrow(() -> new ObjectNotFoundException("Este evento não existe em nossa base de dados"));

    }

    public Event insert(Event obj){
        return repo.insert(obj);
    }

    public Event update(Event event){
        Event newObj = repo.findById(event.getId()).orElse(null);
        updateData(newObj, event);
        return repo.save(newObj);
        
    }

    public void updateData(Event newObj, Event event) {
        newObj.setBloc(event.getBloc());
        newObj.setDate_event(event.getDate_event());
        newObj.setDesc(event.getDesc());
        newObj.setEnd(event.getEnd());
        newObj.setInit(event.getInit());
        newObj.setLink(event.getLink());
        newObj.setName(event.getName());
        newObj.setSector(event.getSector());
        newObj.setTarget(event.getTarget());
        newObj.setType(event.getType());
    }

    public void delete (String id) throws ObjectNotFoundException {
        findById(id);
        repo.deleteById(id);
    }

}