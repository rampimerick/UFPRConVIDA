package br.ufprconvida.services;

import java.util.ArrayList;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class JwtUserDetailsService implements UserDetailsService {

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        if("grr20170244".equals(username)){
            return new User("erick","$2a$10$WCBWy4Z8ms5RSI.Umnx8E.YN0LJjORXlOn0/YQgVEnWYA.nPGNkGq", new ArrayList<>());

        }else if("admin".equals(username)) {
            return new User("admin","$2a$10$gz9USVopohQnQ6piI8Qv7OEt1RFe/Gewp.jq00Z1lcEf6HHHBigOq",new ArrayList<>());
        }else {
            throw new UsernameNotFoundException("User not found");

        }


    }

}