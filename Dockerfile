FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["pipelines-dotnet-core.csproj", ""]
RUN dotnet restore "/pipelines-dotnet-core.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "pipelines-dotnet-core.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "pipelines-dotnet-core.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "pipelines-dotnet-core.dll"]