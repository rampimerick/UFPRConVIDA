package br.ufprconvida.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.ufprconvida.repository.UserRepository;
import br.ufprconvida.domain.User;

import javassist.tools.rmi.ObjectNotFoundException;

@Service
public class UserService {

    @Autowired
    private UserRepository repo;

    public List<User> findAll() {
        return repo.findAll();
    }


    public User findById(String id) throws ObjectNotFoundException {
        Optional <User> user = repo.findById(id);
        return user.orElseThrow(() -> new ObjectNotFoundException("Usuário não cadastrado"));

    }


}