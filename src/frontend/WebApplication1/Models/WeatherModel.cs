namespace WebApplication1.Models;

public class WeatherModel
{
    public DateOnly Date {get; set;}
    public int TemperatureC {get; set;}
    public string? Summary {get; set;}
    public int TemperatureF {get; set;}
}