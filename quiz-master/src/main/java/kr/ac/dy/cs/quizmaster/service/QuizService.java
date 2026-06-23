// 20251258 김상범
// 퀴즈 채점, 결과 저장, 기록 조회 등 퀴즈 관련 비즈니스 로직을 처리하는 서비스 클래스
package kr.ac.dy.cs.quizmaster.service;

import kr.ac.dy.cs.quizmaster.dto.QuizQuestion;
import kr.ac.dy.cs.quizmaster.dto.QuizResult;
import kr.ac.dy.cs.quizmaster.dto.QuizTopic;
import kr.ac.dy.cs.quizmaster.repository.QuizQuestionRepository;
import kr.ac.dy.cs.quizmaster.repository.QuizResultRepository;
import kr.ac.dy.cs.quizmaster.repository.QuizTopicRepository;

import java.time.LocalDateTime;
import java.util.List;

public class QuizService {
    private final QuizTopicRepository topicRepository = new QuizTopicRepository();
    private final QuizQuestionRepository questionRepository = new QuizQuestionRepository();
    private final QuizResultRepository resultRepository = new QuizResultRepository();

    public List<QuizTopic> getAllTopics() {
        return topicRepository.findAll();
    }

    public QuizTopic getTopic(int topicId) {
        return topicRepository.findById(topicId);
    }

    public List<QuizQuestion> getQuestions(int topicId) {
        return questionRepository.findByTopicId(topicId);
    }

    public QuizResult gradeQuiz(String userId, int topicId, List<Integer> userAnswers, List<QuizQuestion> questions) {
        int score = 0;
        for (int i = 0; i < questions.size(); i++) {
            if (i < userAnswers.size() && userAnswers.get(i) == questions.get(i).getCorrectAnswer()) {
                score++;
            }
        }
        QuizResult result = new QuizResult();
        result.setUserId(userId);
        result.setTopicId(topicId);
        result.setScore(score);
        result.setTotal(questions.size());
        result.setAttemptDate(LocalDateTime.now());
        resultRepository.save(result);
        return result;
    }

    public List<QuizResult> getResults(String userId) {
        return resultRepository.findByUserId(userId);
    }
}
