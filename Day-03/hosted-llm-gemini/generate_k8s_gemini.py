import google.generativeai as genai
import os

from grpc import services

# Set your API key here
os.environ["GOOGLE_API_KEY"] = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Configure the Gemini model
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
model = genai.GenerativeModel('gemini-1.5-pro')

PROMPT = """
Generate an ideal Kubernetes YAML file for deploying a {service_type} application with best practices. Just share the YAML file without any explanation between two lines to make copying easy.
Include:
- Namespace
- ConfigMap for environment variables
- Secrets for sensitive data
- Deployment with readiness and liveness probes
- Horizontal Pod Autoscaler (HPA)
- Service of type {service_type}
- Ingress (if applicable) for external access
"""


def generate_k8s(service_type):
    response = model.generate_content(PROMPT.format(service_type=service_type))
    return response.text

if __name__ == '__main__':
    service = input("Please enter the service type (ClusterIP, NodePort, LoadBalancer): ")
    kubernetes = generate_k8s(service)
    print("\nGenerated Kubernetes:\n")
    print(kubernetes)

