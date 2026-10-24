package com.anwar.ticketrush.auth.dto;

import com.anwar.ticketrush.auth.Role;
import jakarta.validation.constraints.*;

public record RegisterRequest(
        @NotBlank @Email String email,
        @NotBlank @Size(min = 8, max = 72) String password,
        Role role) {}