# Fixing Cross-Platform Issues for FastReport.OpenSource on Ubuntu

This guide explains how to make **FastReport.OpenSource** work on **Ubuntu** when developing on **Windows** but deploying to Linux.

## 1. Problem Overview

When running FastReport.OpenSource on Ubuntu, you may encounter:

```
The type initializer for 'Gdip' threw an exception.
```

Or file-related errors like:
```
Interop.ThrowExceptionForIoErrno(...)
SafeFileHandle.Open(...)
OSFileStreamStrategy..ctor(...)
```

These happen because:
- **System.Drawing.Common** needs native `libgdiplus` on Linux.
- Paths differ between Windows (`\`) and Linux (`/`).
- Files might not be deployed or have the wrong case/permissions.

---

## 2. Install Required Libraries on Ubuntu

For **Ubuntu/Debian**:
```bash
sudo apt-get update
sudo apt-get install -y libgdiplus libc6-dev libx11-dev
sudo ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll
```

For **Alpine Linux**:
```bash
apk add --no-cache libgdiplus
```

---

## 3. Enable Unix Support for System.Drawing (.NET 6+)

In `Program.cs` **before** using FastReport:
```csharp
AppContext.SetSwitch("System.Drawing.EnableUnixSupport", true);
```

Or in `.runtimeconfig.json`:
```json
{
  "runtimeOptions": {
    "configProperties": {
      "System.Drawing.EnableUnixSupport": true
    }
  }
}
```

---

## 4. Use Cross-Platform File Paths

Avoid hardcoding `\` in paths.  
Instead of:
```csharp
report.Load($@"{directory}\Reports\{reportName}.frx");
```
Use:
```csharp
string path = Path.Combine(AppContext.BaseDirectory, "Reports", $"{reportName}.frx");
report.Load(path);
```

This ensures the correct separator (`/` or `\`) is used based on OS.

---

## 5. Include `.frx` Files in Publish Output

Add to `.csproj`:
```xml
<ItemGroup>
  <Content Include="Reports\**\*.frx">
    <CopyToOutputDirectory>Always</CopyToOutputDirectory>
  </Content>
</ItemGroup>
```

Then publish:
```bash
dotnet publish -c Release
```

---

## 6. Handle Multiple Projects

If your `ReportUtil` class is in a different project:
- **Option 1:** Copy the `Reports` folder to each project output (use `<Link>` in `.csproj`).
- **Option 2:** Pass the reports path from the calling project.

Example of Option 2:
```csharp
public static void LoadReport(string reportsPath, string reportName)
{
    var path = Path.Combine(reportsPath, $"{reportName}.frx");
    var report = new Report();
    report.Load(path);
}
```

---

## 7. Summary

- Install `libgdiplus` on Linux.
- Enable Unix support for `System.Drawing`.
- Use `Path.Combine` and `AppContext.BaseDirectory`.
- Include `.frx` files in your publish output.
- Handle multi-project paths carefully.

With these steps, FastReport.OpenSource will work seamlessly across Windows development and Ubuntu deployment.
