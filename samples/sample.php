<?php

declare(strict_types=1);

namespace Galewind\Samples;

use DateTimeImmutable;
use InvalidArgumentException;

/**
 * Simple in-memory collection of feature flags.
 */
final class FeatureFlags
{
    /** @var array<string, bool> */
    private array $flags = [];

    public function __construct(
        private readonly string $environment = 'production',
    ) {
    }

    public function enable(string $name): static
    {
        if ($name === '') {
            throw new InvalidArgumentException('flag name cannot be empty');
        }

        $this->flags[$name] = true;

        return $this;
    }

    public function isEnabled(string $name): bool
    {
        return $this->flags[$name] ?? false;
    }

    public function describe(): string
    {
        $stamp = new DateTimeImmutable('now');
        $active = array_keys(array_filter($this->flags));

        return sprintf(
            "[%s] %s: %s",
            $this->environment,
            $stamp->format('Y-m-d'),
            implode(', ', $active) ?: 'none',
        );
    }
}

$flags = (new FeatureFlags('staging'))
    ->enable('new_dashboard')
    ->enable('dark_mode');

echo $flags->describe(), PHP_EOL;
