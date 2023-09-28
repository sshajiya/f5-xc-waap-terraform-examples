#XC Global
api_url = "https://treino.console.ves.volterra.io/api"
xc_tenant = "treino-ufahspac"
xc_namespace = "default"

#XC LB
app_domain = "wafre.f5-hyd-demo.com"

#XC WAF
xc_waf_blocking = true

# pool and LB inputs
k8s_pool = "false"
serviceName = ""
serviceport = ""
advertise_sites = ""
http_only = ""

#XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
xc_app_type = []
xc_multi_lb = false

#XC API Protection and Discovery
xc_api_disc = false
xc_api_pro = false
xc_api_spec = []

#XC Bot Defense
xc_bot_def = false

#XC DDoS
xc_ddos_pro = false

#XC Malicious User Detection
xc_mud = false
