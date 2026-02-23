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

Invoke-Step -Name 'Проверка окружения' -Action {
  Assert-CommandExists -CommandName 'git'
  Assert-CommandExists -CommandName 'flutter'
  if (-not (Test-Path '.git')) {
    throw 'Текущая директория не является git-репозиторием.'
  }
}

Invoke-Step -Name 'Запуск тестов (flutter test)' -Action {
  flutter test
  if ($LASTEXITCODE -ne 0) {
    throw 'Тесты не прошли. Commit и push отменены.'
  }
}

Invoke-Step -Name 'Проверка сборки проекта (flutter build apk --debug)' -Action {
  flutter build apk --debug
  if ($LASTEXITCODE -ne 0) {
    throw 'Сборка не удалась. Commit и push отменены.'
  }
}

Invoke-Step -Name 'Проверка наличия изменений' -Action {
  $status = git status --porcelain
  if ([string]::IsNullOrWhiteSpace(($status -join "`n"))) {
    throw 'Нет изменений для commit. Остановлено.'
  }
}

Invoke-Step -Name 'Commit изменений' -Action {
  git add -A
  git commit -m "$CommitMessage"
  if ($LASTEXITCODE -ne 0) {
    throw 'Commit не выполнен.'
  }
}

Invoke-Step -Name 'Push в удаленный репозиторий' -Action {
  git push
  if ($LASTEXITCODE -ne 0) {
    throw 'Push не выполнен.'
  }
}

Write-Host "`nCI с проверкой сборки завершён успешно: тесты и сборка пройдены, изменения отправлены." -ForegroundColor Green
