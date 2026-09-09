package com.ptw.ptw.config;

import com.ptw.ptw.entity.User;
import com.ptw.ptw.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserService userService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        User user;

        try{
            user = userService.findByUsername(username);
        }catch (RuntimeException e){
            throw new UsernameNotFoundException(
                    "User not found: " + username
            );
        }

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getUsername())
                .password(user.getPassword())
                .authorities(
                        new SimpleGrantedAuthority(
                                "ROLE_" + user.getRole().getRoleName()
                        )
                )
                .disabled(!Boolean.TRUE.equals(user.getActive()))
                .build();
    }
}
