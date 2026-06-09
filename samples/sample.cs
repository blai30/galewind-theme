// C# sample exercising cs-specific token scopes
using System;
using System.Collections.Generic;
using System.Linq;

namespace Galewind.Samples;

/// <summary>Represents an immutable money value in minor units.</summary>
public readonly record struct Money(long Cents, string Currency)
{
    public decimal Amount => Cents / 100m;

    public override string ToString() => $"{Amount:0.00} {Currency}";
}

public interface ILedger
{
    void Record(Money amount, string memo);
    IReadOnlyList<string> History { get; }
}

public sealed class Ledger : ILedger
{
    private readonly List<string> _entries = new();

    public IReadOnlyList<string> History => _entries.AsReadOnly();

    public void Record(Money amount, string memo)
    {
        ArgumentException.ThrowIfNullOrEmpty(memo);
        _entries.Add($"{DateTime.UtcNow:O} {amount} {memo}");
    }

    public static Money Sum(IEnumerable<Money> amounts, string currency)
    {
        long total = amounts
            .Where(value => value.Currency == currency)
            .Sum(value => value.Cents);
        return new Money(total, currency);
    }
}

internal static class Program
{
    private static void Main()
    {
        var ledger = new Ledger();
        Money[] payments = { new(1299, "USD"), new(450, "USD"), new(999, "EUR") };

        foreach (var payment in payments)
        {
            ledger.Record(payment, "invoice");
        }

        Console.WriteLine($"USD total: {Ledger.Sum(payments, "USD")}");
    }
}
