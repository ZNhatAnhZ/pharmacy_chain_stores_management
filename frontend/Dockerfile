# base image
FROM debian:11 AS base

# install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    libgconf-2-4 \
    gdb \
    libstdc++6 \
    libglu1-mesa \
    fonts-droid-fallback \
    lib32stdc++6 \
    python3

# flutter
FROM base AS flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter config --enable-web

# build stage
FROM flutter AS build
WORKDIR /app
COPY pubspec.* ./
RUN flutter clean
RUN flutter pub get
COPY . .
RUN flutter build web --release

# final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/build/web ./
EXPOSE 5000

CMD ["python3", "-m", "http.server", "5000"]
