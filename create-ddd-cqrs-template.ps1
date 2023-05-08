param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

# Create a new .NET Core solution
dotnet new sln -n $ProjectName

# Create the main projects with .NET 7 target framework
dotnet new webapi -n "${ProjectName}.Services.Api" -o "src/Services/${ProjectName}.Services.Api" --framework net7.0
dotnet new classlib -n "${ProjectName}.Application" -o "src/Application/${ProjectName}.Application" --framework net7.0
dotnet new classlib -n "${ProjectName}.Infrastructure" -o "src/Infrastructure/${ProjectName}.Infrastructure" --framework net7.0
dotnet new classlib -n "${ProjectName}.Infrastructure.Identity" -o "src/Infrastructure/${ProjectName}.Infrastructure.Identity" --framework net7.0
dotnet new classlib -n "${ProjectName}.Domain" -o "src/Domain/${ProjectName}.Domain" --framework net7.0
dotnet new classlib -n "${ProjectName}.Domain.Core" -o "src/Domain/${ProjectName}.Domain.Core" --framework net7.0
dotnet new classlib -n "${ProjectName}.CrossCutting" -o "src/CrossCutting/${ProjectName}.CrossCutting" --framework net7.0
dotnet new classlib -n "${ProjectName}.Domain.Persistence" -o "src/Domain/${ProjectName}.Domain.Persistence" --framework net7.0

# Add projects to the solution
dotnet sln add "src/Services/${ProjectName}.Services.Api/${ProjectName}.Services.Api.csproj" --solution-folder "1 - Services"
dotnet sln add "src/Application/${ProjectName}.Application/${ProjectName}.Application.csproj" --solution-folder "2 - Application"
dotnet sln add "src/Infrastructure/${ProjectName}.Infrastructure/${ProjectName}.Infrastructure.csproj" --solution-folder "3 - Infrastructure"
dotnet sln add "src/Infrastructure/${ProjectName}.Infrastructure.Identity/${ProjectName}.Infrastructure.Identity.csproj" --solution-folder "3 - Infrastructure"
dotnet sln add "src/Domain/${ProjectName}.Domain/${ProjectName}.Domain.csproj" --solution-folder "4 - Domain"
dotnet sln add "src/Domain/${ProjectName}.Domain.Core/${ProjectName}.Domain.Core.csproj" --solution-folder "4 - Domain"
dotnet sln add "src/CrossCutting/${ProjectName}.CrossCutting/${ProjectName}.CrossCutting.csproj" --solution-folder "5 - CrossCutting"
dotnet sln add "src/Domain/${ProjectName}.Domain.Persistence/${ProjectName}.Domain.Persistence.csproj" --solution-folder "4 - Domain"

# Set up project references
dotnet add "src/Services/${ProjectName}.Services.Api/${ProjectName}.Services.Api.csproj" reference "src/Application/${ProjectName}.Application/${ProjectName}.Application.csproj"
dotnet add "src/Application/${ProjectName}.Application/${ProjectName}.Application.csproj" reference "src/Domain/${ProjectName}.Domain/${ProjectName}.Domain.csproj"
dotnet add "src/Infrastructure/${ProjectName}.Infrastructure/${ProjectName}.Infrastructure.csproj" reference "src/Domain/${ProjectName}.Domain/${ProjectName}.Domain.csproj"
dotnet add "src/Application/${ProjectName}.Application/${ProjectName}.Application.csproj" reference "src/Infrastructure/${ProjectName}.Infrastructure/${ProjectName}.Infrastructure.csproj"

# Create folders for DDD and CQRS components (continued)
New-Item -ItemType Directory -Path "src/Application/${ProjectName}.Application/Commands"
New-Item -ItemType Directory -Path "src/Application/${ProjectName}.Application/Queries"
New-Item -ItemType Directory -Path "src/Application/${ProjectName}.Application/DTOs"
New-Item -ItemType Directory -Path "src/Domain/${ProjectName}.Domain/Entities"
New-Item -ItemType Directory -Path "src/Domain/${ProjectName}.Domain/ValueObjects"
New-Item -ItemType Directory -Path "src/Domain/${ProjectName}.Domain/Interfaces"
New-Item -ItemType Directory -Path "src/Infrastructure/${ProjectName}.Infrastructure/Repositories"
New-Item -ItemType Directory -Path "src/Infrastructure/${ProjectName}.Infrastructure/Services"
New-Item -ItemType Directory -Path "src/Domain/${ProjectName}.Domain.Persistence/Repositories"

# ...

# Update .csproj files to include folders
$applicationCsproj = "src/Application/${ProjectName}.Application/${ProjectName}.Application.csproj"
$domainCsproj = "src/Domain/${ProjectName}.Domain/${ProjectName}.Domain.csproj"
$infrastructureCsproj = "src/Infrastructure/${ProjectName}.Infrastructure/${ProjectName}.Infrastructure.csproj"
$domainPersistenceCsproj = "src/Domain/${ProjectName}.Domain.Persistence/${ProjectName}.Domain.Persistence.csproj"

(Get-Content $applicationCsproj) -replace '</Project>', '  <ItemGroup>
    <Folder Include="Commands\" />
    <Folder Include="Queries\" />
    <Folder Include="DTOs\" />
  </ItemGroup>
</Project>' | Set-Content $applicationCsproj

(Get-Content $domainCsproj) -replace '</Project>', '  <ItemGroup>
    <Folder Include="Entities\" />
    <Folder Include="ValueObjects\" />
    <Folder Include="Interfaces\" />
  </ItemGroup>
</Project>' | Set-Content $domainCsproj

(Get-Content $infrastructureCsproj) -replace '</Project>', '  <ItemGroup>
    <Folder Include="Repositories\" />
    <Folder Include="Services\" />
  </ItemGroup>
</Project>' | Set-Content $infrastructureCsproj

(Get-Content $domainPersistenceCsproj) -replace '</Project>', '  <ItemGroup>
    <Folder Include="Repositories\" />
  </ItemGroup>
</Project>' | Set-Content $domainPersistenceCsproj
