# Use budtmo/docker-android with Android 11 emulator

FROM budtmo/docker-android:emulator_11.0

# Switch to root user to avoid permission issues
USER root

# Set environment variables
ENV DEVICE="Samsung Galaxy S10" \
    WEB_VNC=true \
    EMULATOR_FRAME_ONLY=true

# Install basic dependencies (optional, kept for flexibility)
RUN mkdir -p /var/lib/apt/lists/partial \
    && apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/*

# Expose ports: 6080 for noVNC (emulator frame), 5900 for full VNC (optional)
EXPOSE 6080 5900

# Start the emulator with noVNC
CMD ["sh", "-c", "emulator -avd android -no-boot-anim -no-window -accel on -gpu swiftshader_indirect & /usr/local/bin/start-vnc.sh"]
