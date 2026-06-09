// Package sample demonstrates Go syntax highlighting.
package sample

import (
	"errors"
	"fmt"
	"sort"
	"strings"
)

// ErrEmpty is returned when no scores are provided.
var ErrEmpty = errors.New("sample: no scores provided")

// Student pairs a name with a numeric score.
type Student struct {
	Name  string
	Score float64
}

// Ranker sorts students and reports summary statistics.
type Ranker interface {
	Rank([]Student) ([]Student, error)
}

type byScore struct{}

func (byScore) Rank(students []Student) ([]Student, error) {
	if len(students) == 0 {
		return nil, ErrEmpty
	}

	ranked := make([]Student, len(students))
	copy(ranked, students)
	sort.SliceStable(ranked, func(left, right int) bool {
		return ranked[left].Score > ranked[right].Score
	})
	return ranked, nil
}

// Summarize formats a leaderboard string for the given students.
func Summarize(students []Student) (string, error) {
	ranked, err := byScore{}.Rank(students)
	if err != nil {
		return "", fmt.Errorf("summarize: %w", err)
	}

	var builder strings.Builder
	for index, student := range ranked {
		fmt.Fprintf(&builder, "%d. %-8s %5.1f\n", index+1, student.Name, student.Score)
	}
	return builder.String(), nil
}
