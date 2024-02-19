using WebApplication1.Models;

namespace WebApplication1.Services;

public class WeatherClient
{
    private readonly HttpClient _httpClient;

    public WeatherClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }
    
    public async Task<WeatherModel[]> GetWeatherAsync()
    {
        return await _httpClient.GetFromJsonAsync<WeatherModel[]>("weatherforecast");
    }
}