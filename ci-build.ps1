param(
  [Parameter(Mandatory = $false)]
  [string]$CommitMessage = "chore: local ci build commit"
)

$ErrorActionPreference = 'Stop'

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Action
  )

  Write-Host "`n==> $Name" -ForegroundColor Cyan
  & $Action
}

function Assert-CommandExists {
  param([string]$CommandName)
  if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
    throw "Required command not found: $CommandName"
  }
}

Invoke-Step -Name 'Environment check' -Action {
  Assert-CommandExists -CommandName 'git'
  Assert-CommandExists -CommandName 'flutter'
  if (-not (Test-Path '.git')) {
    throw "Current directory is not a git repository."
  }
}

Invoke-Step -Name 'Run tests (flutter test)' -Action {
  flutter test
  if ($LASTEXITCODE -ne 0) {
    throw "Tests failed. Commit and push cancelled."
  }
}

Invoke-Step -Name 'Build project check (flutter build apk --debug)' -Action {
  flutter build apk --debug
  if ($LASTEXITCODE -ne 0) {
    throw "Build failed. Commit and push cancelled."
  }
}

Invoke-Step -Name 'Check for changes' -Action {
  $status = git status --porcelain
  if ([string]::IsNullOrWhiteSpace(($status -join "`n"))) {
    throw "No changes to commit. Stopped."
  }
}

Invoke-Step -Name 'Commit changes' -Action {
  git add -A
  git commit -m "$CommitMessage"
  if ($LASTEXITCODE -ne 0) {
    throw "Commit failed."
  }
}

Invoke-Step -Name 'Push to remote repository' -Action {
  git push
  if ($LASTEXITCODE -ne 0) {
    throw "Push failed."
  }
}

Write-Host "`nCI with build check completed successfully: tests and build passed, changes pushed." -ForegroundColor Green
