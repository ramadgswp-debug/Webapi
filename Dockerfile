# 1️⃣ Base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
USER $APP_UID

# 2️⃣ Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["WebApplication2.csproj", "."]
RUN dotnet restore "./WebApplication2.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./WebApplication2.csproj" -c $BUILD_CONFIGURATION -o /app/build

# 3️⃣ Publish stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./WebApplication2.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# 4️⃣ Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY localhost.pfx /https/localhost.pfx

ENV ASPNETCORE_URLS="http://+:8080;https://+:8081"
ENV ASPNETCORE_Kestrel__Certificates__Default__Path=/https/localhost.pfx
ENV ASPNETCORE_Kestrel__Certificates__Default__Password=YourSecurePassword

ENTRYPOINT ["dotnet", "WebApplication2.dll"]
