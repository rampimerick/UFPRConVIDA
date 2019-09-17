/*package br.ufprconvida.config;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.TimeZone;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;

import br.ufprconvida.domain.Event;
import br.ufprconvida.repository.EventRepository;


@Configuration
public class Init implements CommandLineRunner {

@Autowired
private EventRepository eventRepository;

 
@Override
public void run(String... arg0) throws Exception{

SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
sdf.setTimeZone(TimeZone.getTimeZone("GMT"));

eventRepository.deleteAll();

Event event1 = new Event(null, "Reunião dos Cornos", "Os Cornos", sdf.parse("09/09/2019"), "Melhor reunião de cornos da América Latina", sdf.parse("09/08/2019"), sdf.parse("08/09/2019"), "wwww.socornos.com.br", "Corno");
Event event2 = new Event(null, "Reuniao", "alunos", sdf.parse("26/06/2020"), "Grande reunião", sdf.parse("03/03/2019"), sdf.parse("04/04/2019"), "www.www.www", "Reunião");



eventRepository.saveAll(Arrays.asList(event1,event2));

}


}
*/