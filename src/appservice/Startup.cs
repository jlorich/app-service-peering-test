using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace appservice
{
    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
        }

        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.Run(async (context) =>
            {
                var client = HttpClientFactory.Create();
                
                var url = Configuration.GetValue<string>("VmUrl");
                client.Timeout = TimeSpan.FromSeconds(3);

                try {
                    var res = await client.GetAsync(url);
                    var body = await res.Content.ReadAsStringAsync();
                    await context.Response.WriteAsync(body);
                } catch (Exception e) {
                    await context.Response.WriteAsync($"Could not connect to server: {url}\n");
                    await context.Response.WriteAsync(e.ToString());
                }
            });
        }
    }
}
