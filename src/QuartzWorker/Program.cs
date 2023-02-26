using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using QuartzTests.QuartzWorker;

await WaitForDatabase();

var appBuilder = Host
	.CreateDefaultBuilder(args)
	.ConfigureAppConfiguration((hbc, cb) =>
	{
		cb.AddJsonFile("appsettings.json", optional: false);
		if (hbc.HostingEnvironment.IsDevelopment())
			cb.AddJsonFile("appsettings.Development.json", optional: false);
	})
	.ConfigureServices((hbc, sc) => { sc.AddQuartz(hbc.Configuration); });

var app = appBuilder.Build();

await app.RunAsync();


async Task WaitForDatabase()
{
	var shouldWait = (Environment.GetEnvironmentVariable("WAIT_FOR_DATABASE") ?? "true").ToLowerInvariant();
	if (shouldWait != "true")
		return;

	Console.WriteLine("Waiting for ten seconds for database");
	for (var i = 0; i < 10; i++)
	{
		Console.Write(".");
		await Task.Delay(TimeSpan.FromSeconds(1));
	}

	Console.WriteLine();
	Console.WriteLine("Starting app");
}