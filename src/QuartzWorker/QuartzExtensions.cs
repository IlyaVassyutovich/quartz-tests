using Microsoft.Extensions.DependencyInjection;
using Quartz;

namespace QuartzTests.QuartzWorker;

internal static class QuartzExtensions
{
	public static IServiceCollection AddQuartz(this IServiceCollection services)
	{
		services.AddQuartz(qc =>
		{
			qc.UseMicrosoftDependencyInjectionJobFactory();

			qc.SchedulerId = BuildSchedulerId();
			qc.SchedulerName = "default-scheduler";

			qc.UseInMemoryStore();

			qc.ScheduleJob<TestJob>(
				tc =>
				{
					tc
						.WithIdentity("TestJob_trigger")
						.StartNow()
						.WithSimpleSchedule(sb => sb.WithInterval(TimeSpan.FromSeconds(30)).RepeatForever());
				},
				jc =>
				{
					jc
						.WithIdentity("TestJob_job")
						.DisallowConcurrentExecution();
				});
		});
		services.AddQuartzHostedService(o => { o.WaitForJobsToComplete = true; });

		return services;
	}

	private static string BuildSchedulerId()
	{
		return $"{Environment.MachineName}-{Environment.GetEnvironmentVariable("QUARTZ_SCHEDULER_ID") ?? "UNKNOWN"}";
	}
}