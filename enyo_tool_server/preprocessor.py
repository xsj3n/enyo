from transformers import AutoModelForCausalLM
import guidance
import torch

model = AutoModelForCausalLM.from_pretrained("open-thoughts/OpenThinker-7B", low_cpu_mem_usage=True, torch_dtype=torch.float16)
guidance_model = models.Transformers(model)

@guidance
def tool_check(lm, quenry):
    lm += f'''
    You are a preprocessing AI that examines the user's queries first.
    According to the user's query, pick an appropriate function from a menu included at the bottom.
    
    Return true if the user is asking a question & it requires live data an LLM
    would not have access to. 

    Choice: {guidance.select(["true", "false",], name="choice")}
    '''
    return lm

result = tool_check(guidance_model, "Hey, how is it going?")
print("result: " + result["choice"])
