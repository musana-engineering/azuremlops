from azure.ai.ml import MLClient
from azure.ai.ml.entities import WorkspaceConnection
from azure.ai.ml.entities import UsernamePasswordConfiguration
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv
import os

# Load environment variables from a .env file
load_dotenv()

# Workspace Connection
subscriptionId = os.environ.get("SUBSCRIPTION_ID")
resourceGroup = os.environ.get("RESOURCE_GROUP")
workspace = os.environ.get("AML_WORKSPACE_NAME")

# Client ID associated with service principal.
AZURE_CLIENT_ID = os.environ.get("AZURE_CLIENT_ID")
# Tenant ID associated with service principal. 
AZURE_TENANT_ID = os.environ.get("AZURE_TENANT_ID")
# Client secret associated with service principal.
AZURE_CLIENT_SECRET = os.environ.get("AZURE_CLIENT_SECRET")

ml_client = MLClient(
    DefaultAzureCredential(),
    subscriptionId,
    resourceGroup,
    workspace
)

# Snowflake Connection
SF_Warehouse="COMPUTE_WH"
SF_Database="ML_DATASETS_DB"
SF_Role="MLOPS"
SF_Username = os.environ.get("SNOWFLAKE_USERNAME")
SF_Password = os.environ.get("SNOWFLAKE_PASSWORD")

SF_ConnectionString = f"jdbc:snowflake://WRJAZGI-FBA89331.snowflakecomputing.com/?db={SF_Database}&Warehouse={SF_Warehouse}&role={SF_Role}"

ML_DataConnection = WorkspaceConnection(
    name="dataconn-snowflake",
    type='snowflake',
    target=SF_ConnectionString,
    credentials=UsernamePasswordConfiguration(
        username=SF_Username,
        password=SF_Password
    )
)

ml_client.connections.create_or_update(
    workspace_connection=ML_DataConnection
)