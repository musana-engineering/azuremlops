from azure.ai.ml import MLClient
from azure.identity import DefaultAzureCredential
import os 
from dotenv import load_dotenv


subscriptionId = os.environ.get("SUBSCRIPTION_ID")
resourceGroup = os.environ.get("RESOURCE_GROUP")
workspace = os.environ.get("AML_WORKSPACE_NAME")

ml_client = MLClient(
    DefaultAzureCredential(),
    subscriptionId,
    resourceGroup,
    workspace
)