using System.Text;
using Microsoft.Extensions.Logging;
using Quartz;

namespace QuartzTests.QuartzWorker;

internal class TestJob : IJob
{
	private readonly ILogger<TestJob> logger;

	public TestJob(ILogger<TestJob> logger)
	{
		this.logger = logger;
	}
	
	public async Task Execute(IJobExecutionContext context)
	{
		var messageBase = new StringBuilder()
			.AppendLine($"nameof(TestJob) ::: {context.FireInstanceId}")
			.AppendLine($"Scheduler: {context.Scheduler.SchedulerInstanceId}")
			.AppendLine($"Trigger: {context.Trigger.Key}")
			.AppendLine(
				$"Job: {context.JobDetail.Key}, "
				+ $"concurrency disallowed: {context.JobDetail.ConcurrentExecutionDisallowed}")
			.ToString();

		logger.LogInformation(messageBase + "<BEGIN>");

		await Task.Delay(TimeSpan.FromSeconds(20), context.CancellationToken);

		logger.LogInformation(messageBase + "<END>");
	}
}