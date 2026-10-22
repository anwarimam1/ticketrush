package com.anwar.ticketrush.auth.dto;

public record AuthResponse(String token, String tokenType, long expiresInSeconds) {}