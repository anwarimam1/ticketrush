package com.anwar.ticketrush.auth;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Service;

import com.anwar.ticketrush.auth.User;

import java.time.Instant;

@Service
public class JwtService {

    private final JwtEncoder encoder;
    private final long expirySeconds;

    public JwtService(JwtEncoder encoder, @Value("${app.jwt.expiry-seconds}") long expirySeconds) {
        this.encoder = encoder;
        this.expirySeconds = expirySeconds;
    }

    public long getExpirySeconds() { return expirySeconds; }

    public String generate(User user) {
        Instant now = Instant.now();
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer("ticketrush")
                .issuedAt(now)
                .expiresAt(now.plusSeconds(expirySeconds))
                .subject(String.valueOf(user.getId()))
                .claim("email", user.getEmail())
                .claim("role", user.getRole().name())
                .build();
        JwsHeader header = JwsHeader.with(MacAlgorithm.HS256).build();
        return encoder.encode(JwtEncoderParameters.from(header, claims)).getTokenValue();
    }
}