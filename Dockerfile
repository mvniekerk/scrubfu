#
# *************************************************
# Copyright (c) 2019, Grindrod Bank Limited
# License MIT: https://opensource.org/licenses/MIT
# **************************************************
#

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build
WORKDIR /app/scrubfu

# copy csproj and restore as distinct layers
COPY ./src/ ./src
COPY ./tests ./tests
COPY ./scrubfu.sln ./scrubfu.sln
COPY ./scrubfu.alias ./scrubfu.alias
WORKDIR /app/scrubfu
RUN dotnet restore

WORKDIR /app/scrubfu/src/scrubfu
RUN dotnet publish -c Release -r linux-musl-x64 -o out /p:PublishSingleFile=true /p:PublishTrimmed=true

FROM mcr.microsoft.com/dotnet/core/runtime-deps:3.1-alpine AS runtime
WORKDIR /app
COPY --from=build /app/scrubfu/src/scrubfu/out/ ./
ENTRYPOINT ["./scrubfu"]