using Amazon;
using Amazon.XRay.Recorder.Core;
using Amazon.XRay.Recorder.Core.Strategies;
using Amazon.XRay.Recorder.Handlers.AwsSdk;
using Amazon.XRay.Recorder.Handlers.System.Net;
using WebApplication1.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

AWSXRayRecorder.RegisterLogger(LoggingOptions.Console);
var recorder = new AWSXRayRecorderBuilder()
    .WithContextMissingStrategy(ContextMissingStrategy.LOG_ERROR)
    .Build();
AWSXRayRecorder.InitializeInstance(recorder: recorder);
AWSSDKHandler.RegisterXRayForAllServices();

builder.Services.AddHttpClient<WeatherClient>(options => options.BaseAddress = new Uri("http://weather-api.weather.private:8080"))
    .ConfigurePrimaryHttpMessageHandler(() => new HttpClientXRayTracingHandler(new HttpClientHandler()));

builder.Services.AddHealthChecks();

var app = builder.Build();

app.UseXRay("Weather-FrontEnd");

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHealthChecks("/health");

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();