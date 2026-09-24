from __future__ import annotations

import hashlib
import logging
import time
from dataclasses import dataclass
from typing import Any, Dict, Optional

import requests

from config import OllamaSettings


LOGGER = logging.getLogger(__name__)


@dataclass(frozen=True)
class InferenceResult:
    success: bool
    latency_ms: float
    timestamp_utc: str
    model_name: str
    error: Optional[str]
    response_chars: Optional[int]
    response_digest: Optional[str]
    eval_count: Optional[int]
    eval_duration_ns: Optional[int]
    prompt_eval_count: Optional[int]
    prompt_eval_duration_ns: Optional[int]
    total_duration_ns: Optional[int]
    load_duration_ns: Optional[int]
    tokens_per_second: Optional[float]


class OllamaClient:
    def __init__(self, settings: OllamaSettings) -> None:
        self.settings = settings
        self.session = requests.Session()

    def _generate_payload(
        self,
        prompt: str,
        max_tokens: Optional[int] = None,
        temperature: Optional[float] = None,
    ) -> Dict[str, Any]:
        return {
            "model": self.settings.model,
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": self.settings.temperature if temperature is None else temperature,
                "num_predict": self.settings.max_tokens if max_tokens is None else max_tokens,
            },
        }

    def generate(
        self,
        prompt: str,
        *,
        max_tokens: Optional[int] = None,
        temperature: Optional[float] = None,
    ) -> InferenceResult:
        endpoint = f"{self.settings.base_url}/api/generate"
        request_started = time.perf_counter()
        timestamp_utc = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())

        try:
            response = self.session.post(
                endpoint,
                json=self._generate_payload(prompt, max_tokens=max_tokens, temperature=temperature),
                timeout=self.settings.request_timeout_s,
            )
            latency_ms = (time.perf_counter() - request_started) * 1000.0
            response.raise_for_status()
            payload = response.json()

            eval_count = payload.get("eval_count")
            eval_duration_ns = payload.get("eval_duration")
            tokens_per_second = None
            if eval_count and eval_duration_ns:
                tokens_per_second = float(eval_count) / (float(eval_duration_ns) / 1_000_000_000.0)

            response_text = payload.get("response", "")
            response_digest = hashlib.sha256(response_text.encode("utf-8")).hexdigest()[:16]

            return InferenceResult(
                success=True,
                latency_ms=latency_ms,
                timestamp_utc=timestamp_utc,
                model_name=self.settings.model,
                error=None,
                response_chars=len(response_text),
                response_digest=response_digest,
                eval_count=int(eval_count) if eval_count is not None else None,
                eval_duration_ns=int(eval_duration_ns) if eval_duration_ns is not None else None,
                prompt_eval_count=int(payload["prompt_eval_count"])
                if payload.get("prompt_eval_count") is not None
                else None,
                prompt_eval_duration_ns=int(payload["prompt_eval_duration"])
                if payload.get("prompt_eval_duration") is not None
                else None,
                total_duration_ns=int(payload["total_duration"])
                if payload.get("total_duration") is not None
                else None,
                load_duration_ns=int(payload["load_duration"])
                if payload.get("load_duration") is not None
                else None,
                tokens_per_second=tokens_per_second,
            )
        except (requests.RequestException, ValueError) as exc:
            latency_ms = (time.perf_counter() - request_started) * 1000.0
            LOGGER.warning("Ollama request failed: %s", exc)
            return InferenceResult(
                success=False,
                latency_ms=latency_ms,
                timestamp_utc=timestamp_utc,
                model_name=self.settings.model,
                error=str(exc),
                response_chars=None,
                response_digest=None,
                eval_count=None,
                eval_duration_ns=None,
                prompt_eval_count=None,
                prompt_eval_duration_ns=None,
                total_duration_ns=None,
                load_duration_ns=None,
                tokens_per_second=None,
            )

    def warmup(self, prompt: str) -> InferenceResult:
        LOGGER.info("Running Ollama warmup request against model %s", self.settings.model)
        return self.generate(prompt=prompt, max_tokens=min(16, self.settings.max_tokens))
