FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /build
RUN ls
COPY ["src/QuartzWorker/QuartzWorker.csproj", "build/QuartzWorker/"]
RUN dotnet restore "build/QuartzWorker/QuartzWorker.csproj"
COPY . .
RUN ls
WORKDIR "/build/src/QuartzWorker"
RUN ls
RUN dotnet build "QuartzWorker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "QuartzWorker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "QuartzWorker.dll"]
