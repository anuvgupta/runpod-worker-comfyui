from .templates.stable_diffusion_scribble import build_workflow_loader

SD_CHECKPOINT_NAME = "juggernautXL_juggXILightningByRD.safetensors"
CONTROLNET_NAME = "diffusion_pytorch_model.safetensors"
NEGATIVE_PROMPT = "text, watermark, blurry, low quality, bad quality"
SAMPLER_ALGORITHM = "dpmpp_sde"
SAMPLER_SCHEDULER = "normal"
SAMPLER_CFG = 1.5
SAMPLER_STEPS = 6
SAMPLER_DENOISE = 1
CONTROLNET_STRENGTH = 0.9
MAX_IMAGE_SIZE = 1024

load = build_workflow_loader(
    SD_CHECKPOINT_NAME,
    NEGATIVE_PROMPT,
    MAX_IMAGE_SIZE,
    SAMPLER_STEPS,
    SAMPLER_CFG,
    SAMPLER_ALGORITHM,
    SAMPLER_SCHEDULER,
    SAMPLER_DENOISE,
    CONTROLNET_NAME,
    CONTROLNET_STRENGTH,
)
