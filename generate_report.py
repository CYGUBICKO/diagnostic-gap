import pprint
import configparser
import google.generativeai as palm

config = configparser.ConfigParser()
config.read('api_config.ini')
api_key = config['GAI']['api_key']

palm.configure(api_key=api_key)

models = [m for m in palm.list_models() if 'generateText' in m.supported_generation_methods]
model = models[0].name

prompt = open("results_forgai.Rout.txt", 'r').read()

completion = palm.generate_text(
    model=model,
    prompt=prompt,
    temperature=0.5,
    # The maximum length of the response
    max_output_tokens=100000,
)

print(completion.result)
