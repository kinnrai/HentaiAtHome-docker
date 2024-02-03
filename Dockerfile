FROM openjdk:8-jre-alpine

LABEL maintainer="Kinnrai <me@kinnrai.com>"

# Install necessary packages and set timezone
ENV TZ="UTC"
RUN apk add --no-cache tzdata wget unzip && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create working directory
WORKDIR /home/hath

# Set the version and SHA-256 value, download and unzip HentaiAtHome, and then clean up unnecessary files.
ARG HatH_VERSION
ARG HatH_SHA256
RUN wget https://repo.e-hentai.org/hath/HentaiAtHome_${HatH_VERSION}.zip -O HentaiAtHome.zip && \
    echo "${HatH_SHA256}  HentaiAtHome.zip" | sha256sum -c - || \
    (echo "SHA256 hash verification failed!" && exit 1) && \
    unzip HentaiAtHome.zip && \
    rm HentaiAtHome.zip autostartgui.bat HentaiAtHomeGUI.jar && \
    apk del wget unzip

# Set the client ID and key
ENV CLIENT_ID=""
ENV CLIENT_KEY=""

# Write the credentials file, and then run the Hentai@Home client
ENTRYPOINT ["sh", "-c", "echo -n ${CLIENT_ID}-${CLIENT_KEY} > /home/hath/data/client_login && java -jar HentaiAtHome.jar"]
