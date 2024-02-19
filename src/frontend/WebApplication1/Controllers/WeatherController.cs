using Microsoft.AspNetCore.Mvc;
using WebApplication1.Services;

namespace WebApplication1.Controllers;

public class WeatherController : Controller
{
    private readonly WeatherClient _weatherClient;

    public WeatherController(WeatherClient weatherClient)
    {
        _weatherClient = weatherClient;
    }

    // GET
    public async Task<IActionResult> Index()
    {
        var weather = await _weatherClient.GetWeatherAsync();
        return View(weather);
    }
}