package br.ufprconvida.repository;


import br.ufprconvida.domain.Location;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface LocationRepository extends MongoRepository<Location, String>{


}