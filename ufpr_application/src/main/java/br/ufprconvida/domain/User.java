package br.ufprconvida.domain;

import java.io.Serializable;
import java.util.Objects;

import org.springframework.data.annotation.Id;

public class User implements Serializable{

    private static final long serialVersionUID = 1L;
    
    @Id
    private String grr;
    private String name;
    private String lastName;
    private String password;
    private String email;


    public User() {
    }


    public User(String grr, String name, String lastName, String password, String email) {
        this.grr = grr;
        this.name = name;
        this.lastName = lastName;
        this.password = password;
        this.email = email;
    }
    


    public String getGrr() {
        return this.grr;
    }

    public void setGrr(String grr) {
        this.grr = grr;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLastName() {
        return this.lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof User)) {
            return false;
        }
        User user = (User) o;
        return Objects.equals(grr, user.grr) && Objects.equals(name, user.name) && Objects.equals(lastName, user.lastName) && Objects.equals(password, user.password) && Objects.equals(email, user.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(grr, name, lastName, password, email);
    }






}